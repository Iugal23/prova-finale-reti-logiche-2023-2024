-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb is
end project_tb;

architecture project_tb_arch of project_tb is
    constant CLOCK_PERIOD : time := 20 ns;
    signal tb_clk : std_logic := '0';
    signal tb_rst, tb_start, tb_done : std_logic;
    signal tb_add : std_logic_vector(15 downto 0);
    signal tb_k   : std_logic_vector(9 downto 0);

    signal tb_o_mem_addr, exc_o_mem_addr, init_o_mem_addr : std_logic_vector(15 downto 0);
    signal tb_o_mem_data, exc_o_mem_data, init_o_mem_data : std_logic_vector(7 downto 0);
    signal tb_i_mem_data : std_logic_vector(7 downto 0);
    signal tb_o_mem_we, tb_o_mem_en, exc_o_mem_we, exc_o_mem_en, init_o_mem_we, init_o_mem_en : std_logic;

    type ram_type is array (65535 downto 0) of std_logic_vector(7 downto 0);
    signal RAM : ram_type := (OTHERS => "00000000");

constant SCENARIO_LENGTH : integer := 545;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (125,0,11,0,98,0,226,0,233,0,0,0,236,0,178,0,253,0,224,0,78,0,45,0,134,0,97,0,180,0,189,0,30,0,101,0,216,0,73,0,0,0,186,0,0,0,2,0,63,0,43,0,34,0,43,0,0,0,175,0,199,0,201,0,231,0,197,0,41,0,82,0,35,0,22,0,170,0,6,0,25,0,171,0,0,0,163,0,240,0,0,0,138,0,55,0,0,0,245,0,135,0,154,0,243,0,0,0,0,0,140,0,79,0,25,0,28,0,241,0,0,0,0,0,96,0,101,0,191,0,223,0,136,0,152,0,183,0,0,0,93,0,205,0,93,0,67,0,132,0,221,0,240,0,91,0,24,0,0,0,0,0,128,0,0,0,212,0,30,0,45,0,118,0,79,0,25,0,83,0,0,0,13,0,114,0,156,0,0,0,206,0,82,0,200,0,0,0,179,0,97,0,0,0,195,0,56,0,0,0,0,0,141,0,121,0,214,0,0,0,0,0,0,0,0,0,155,0,23,0,133,0,94,0,0,0,129,0,123,0,249,0,0,0,91,0,224,0,0,0,25,0,103,0,156,0,150,0,211,0,115,0,0,0,0,0,201,0,0,0,0,0,61,0,0,0,140,0,147,0,237,0,0,0,63,0,0,0,181,0,0,0,110,0,0,0,139,0,55,0,32,0,149,0,204,0,96,0,170,0,9,0,87,0,31,0,36,0,0,0,0,0,152,0,230,0,121,0,221,0,243,0,0,0,198,0,245,0,61,0,239,0,118,0,224,0,78,0,203,0,63,0,228,0,0,0,0,0,33,0,166,0,72,0,69,0,162,0,145,0,158,0,59,0,98,0,219,0,93,0,86,0,10,0,39,0,155,0,216,0,68,0,0,0,19,0,42,0,108,0,137,0,180,0,66,0,0,0,229,0,211,0,197,0,0,0,133,0,240,0,183,0,0,0,168,0,22,0,148,0,0,0,0,0,201,0,167,0,0,0,0,0,227,0,0,0,134,0,0,0,115,0,151,0,24,0,112,0,27,0,67,0,0,0,23,0,124,0,146,0,114,0,0,0,0,0,135,0,0,0,19,0,0,0,0,0,0,0,0,0,72,0,21,0,218,0,157,0,195,0,0,0,0,0,254,0,56,0,239,0,220,0,202,0,65,0,107,0,54,0,66,0,0,0,114,0,44,0,165,0,23,0,0,0,79,0,181,0,0,0,49,0,99,0,184,0,173,0,9,0,89,0,108,0,82,0,0,0,0,0,57,0,97,0,184,0,0,0,250,0,126,0,0,0,86,0,0,0,111,0,135,0,215,0,0,0,1,0,107,0,6,0,255,0,0,0,221,0,0,0,0,0,85,0,216,0,0,0,134,0,114,0,232,0,245,0,255,0,169,0,90,0,170,0,0,0,252,0,14,0,122,0,217,0,54,0,70,0,10,0,0,0,90,0,231,0,164,0,59,0,74,0,108,0,74,0,223,0,0,0,221,0,0,0,190,0,0,0,209,0,197,0,163,0,6,0,119,0,77,0,0,0,114,0,185,0,150,0,0,0,70,0,232,0,0,0,24,0,185,0,132,0,0,0,10,0,142,0,29,0,147,0,0,0,115,0,19,0,34,0,138,0,0,0,1,0,64,0,51,0,8,0,0,0,0,0,230,0,20,0,35,0,172,0,56,0,129,0,173,0,0,0,87,0,226,0,60,0,191,0,33,0,0,0,32,0,0,0,238,0,8,0,0,0,118,0,114,0,199,0,32,0,35,0,89,0,126,0,213,0,126,0,11,0,0,0,89,0,211,0,7,0,132,0,139,0,0,0,237,0,178,0,59,0,228,0,216,0,32,0,204,0,105,0,185,0,81,0,194,0,15,0,174,0,11,0,141,0,138,0,118,0,172,0,173,0,208,0,70,0,87,0,205,0,0,0,53,0,162,0,149,0,68,0,107,0,27,0,91,0,63,0,68,0,131,0,207,0,100,0,66,0,82,0,7,0,188,0,37,0,224,0,85,0,115,0,0,0,213,0,0,0,86,0,0,0,0,0,249,0,28,0,0,0,34,0,176,0,221,0,51,0,0,0,79,0,182,0,218,0,158,0,72,0,132,0,0,0,25,0,183,0,0,0,62,0,218,0,0,0,153,0,185,0,187,0,117,0,20,0,0,0,0,0,0,0,107,0,0,0,243,0,182,0,227,0,98,0,157,0,57,0,43,0,0,0,53,0,146,0,213,0,100,0,166,0,242,0,240,0,140,0,204,0,85,0,213,0,0,0,88,0,119,0,63,0,188,0,12,0,11,0,159,0,154,0,112,0,240,0,6,0,179,0,158,0,0,0,0,0,45,0,39,0,158,0,42,0,40,0,40,0,178,0,33,0,152,0,99,0,99,0,185,0,241,0,0,0,0,0,206,0,185,0,91,0,41,0,251,0,0,0,207,0,0,0,208,0,6,0);
signal scenario_full  : scenario_type := (125,31,11,31,98,31,226,31,233,31,233,30,236,31,178,31,253,31,224,31,78,31,45,31,134,31,97,31,180,31,189,31,30,31,101,31,216,31,73,31,73,30,186,31,186,30,2,31,63,31,43,31,34,31,43,31,43,30,175,31,199,31,201,31,231,31,197,31,41,31,82,31,35,31,22,31,170,31,6,31,25,31,171,31,171,30,163,31,240,31,240,30,138,31,55,31,55,30,245,31,135,31,154,31,243,31,243,30,243,29,140,31,79,31,25,31,28,31,241,31,241,30,241,29,96,31,101,31,191,31,223,31,136,31,152,31,183,31,183,30,93,31,205,31,93,31,67,31,132,31,221,31,240,31,91,31,24,31,24,30,24,29,128,31,128,30,212,31,30,31,45,31,118,31,79,31,25,31,83,31,83,30,13,31,114,31,156,31,156,30,206,31,82,31,200,31,200,30,179,31,97,31,97,30,195,31,56,31,56,30,56,29,141,31,121,31,214,31,214,30,214,29,214,28,214,27,155,31,23,31,133,31,94,31,94,30,129,31,123,31,249,31,249,30,91,31,224,31,224,30,25,31,103,31,156,31,150,31,211,31,115,31,115,30,115,29,201,31,201,30,201,29,61,31,61,30,140,31,147,31,237,31,237,30,63,31,63,30,181,31,181,30,110,31,110,30,139,31,55,31,32,31,149,31,204,31,96,31,170,31,9,31,87,31,31,31,36,31,36,30,36,29,152,31,230,31,121,31,221,31,243,31,243,30,198,31,245,31,61,31,239,31,118,31,224,31,78,31,203,31,63,31,228,31,228,30,228,29,33,31,166,31,72,31,69,31,162,31,145,31,158,31,59,31,98,31,219,31,93,31,86,31,10,31,39,31,155,31,216,31,68,31,68,30,19,31,42,31,108,31,137,31,180,31,66,31,66,30,229,31,211,31,197,31,197,30,133,31,240,31,183,31,183,30,168,31,22,31,148,31,148,30,148,29,201,31,167,31,167,30,167,29,227,31,227,30,134,31,134,30,115,31,151,31,24,31,112,31,27,31,67,31,67,30,23,31,124,31,146,31,114,31,114,30,114,29,135,31,135,30,19,31,19,30,19,29,19,28,19,27,72,31,21,31,218,31,157,31,195,31,195,30,195,29,254,31,56,31,239,31,220,31,202,31,65,31,107,31,54,31,66,31,66,30,114,31,44,31,165,31,23,31,23,30,79,31,181,31,181,30,49,31,99,31,184,31,173,31,9,31,89,31,108,31,82,31,82,30,82,29,57,31,97,31,184,31,184,30,250,31,126,31,126,30,86,31,86,30,111,31,135,31,215,31,215,30,1,31,107,31,6,31,255,31,255,30,221,31,221,30,221,29,85,31,216,31,216,30,134,31,114,31,232,31,245,31,255,31,169,31,90,31,170,31,170,30,252,31,14,31,122,31,217,31,54,31,70,31,10,31,10,30,90,31,231,31,164,31,59,31,74,31,108,31,74,31,223,31,223,30,221,31,221,30,190,31,190,30,209,31,197,31,163,31,6,31,119,31,77,31,77,30,114,31,185,31,150,31,150,30,70,31,232,31,232,30,24,31,185,31,132,31,132,30,10,31,142,31,29,31,147,31,147,30,115,31,19,31,34,31,138,31,138,30,1,31,64,31,51,31,8,31,8,30,8,29,230,31,20,31,35,31,172,31,56,31,129,31,173,31,173,30,87,31,226,31,60,31,191,31,33,31,33,30,32,31,32,30,238,31,8,31,8,30,118,31,114,31,199,31,32,31,35,31,89,31,126,31,213,31,126,31,11,31,11,30,89,31,211,31,7,31,132,31,139,31,139,30,237,31,178,31,59,31,228,31,216,31,32,31,204,31,105,31,185,31,81,31,194,31,15,31,174,31,11,31,141,31,138,31,118,31,172,31,173,31,208,31,70,31,87,31,205,31,205,30,53,31,162,31,149,31,68,31,107,31,27,31,91,31,63,31,68,31,131,31,207,31,100,31,66,31,82,31,7,31,188,31,37,31,224,31,85,31,115,31,115,30,213,31,213,30,86,31,86,30,86,29,249,31,28,31,28,30,34,31,176,31,221,31,51,31,51,30,79,31,182,31,218,31,158,31,72,31,132,31,132,30,25,31,183,31,183,30,62,31,218,31,218,30,153,31,185,31,187,31,117,31,20,31,20,30,20,29,20,28,107,31,107,30,243,31,182,31,227,31,98,31,157,31,57,31,43,31,43,30,53,31,146,31,213,31,100,31,166,31,242,31,240,31,140,31,204,31,85,31,213,31,213,30,88,31,119,31,63,31,188,31,12,31,11,31,159,31,154,31,112,31,240,31,6,31,179,31,158,31,158,30,158,29,45,31,39,31,158,31,42,31,40,31,40,31,178,31,33,31,152,31,99,31,99,31,185,31,241,31,241,30,241,29,206,31,185,31,91,31,41,31,251,31,251,30,207,31,207,30,208,31,6,31);

    signal memory_control : std_logic := '0';
    
    constant SCENARIO_ADDRESS : integer := 1234;

    component project_reti_logiche is
        port (
                i_clk : in std_logic;
                i_rst : in std_logic;
                i_start : in std_logic;
                i_add : in std_logic_vector(15 downto 0);
                i_k   : in std_logic_vector(9 downto 0);
                
                o_done : out std_logic;
                
                o_mem_addr : out std_logic_vector(15 downto 0);
                i_mem_data : in  std_logic_vector(7 downto 0);
                o_mem_data : out std_logic_vector(7 downto 0);
                o_mem_we   : out std_logic;
                o_mem_en   : out std_logic
        );
    end component project_reti_logiche;

begin
    UUT : project_reti_logiche
    port map(
                i_clk   => tb_clk,
                i_rst   => tb_rst,
                i_start => tb_start,
                i_add   => tb_add,
                i_k     => tb_k,
                
                o_done => tb_done,
                
                o_mem_addr => exc_o_mem_addr,
                i_mem_data => tb_i_mem_data,
                o_mem_data => exc_o_mem_data,
                o_mem_we   => exc_o_mem_we,
                o_mem_en   => exc_o_mem_en
    );

    -- Clock generation
    tb_clk <= not tb_clk after CLOCK_PERIOD/2;

    -- Process related to the memory
    MEM : process (tb_clk)
    begin
        if tb_clk'event and tb_clk = '1' then
            if tb_o_mem_en = '1' then
                if tb_o_mem_we = '1' then
                    RAM(to_integer(unsigned(tb_o_mem_addr))) <= tb_o_mem_data after 1 ns;
                    tb_i_mem_data <= tb_o_mem_data after 1 ns;
                else
                    tb_i_mem_data <= RAM(to_integer(unsigned(tb_o_mem_addr))) after 1 ns;
                end if;
            end if;
        end if;
    end process;
    
    memory_signal_swapper : process(memory_control, init_o_mem_addr, init_o_mem_data,
                                    init_o_mem_en,  init_o_mem_we,   exc_o_mem_addr,
                                    exc_o_mem_data, exc_o_mem_en, exc_o_mem_we)
    begin
        -- This is necessary for the testbench to work: we swap the memory
        -- signals from the component to the testbench when needed.
    
        tb_o_mem_addr <= init_o_mem_addr;
        tb_o_mem_data <= init_o_mem_data;
        tb_o_mem_en   <= init_o_mem_en;
        tb_o_mem_we   <= init_o_mem_we;

        if memory_control = '1' then
            tb_o_mem_addr <= exc_o_mem_addr;
            tb_o_mem_data <= exc_o_mem_data;
            tb_o_mem_en   <= exc_o_mem_en;
            tb_o_mem_we   <= exc_o_mem_we;
        end if;
    end process;
    
    -- This process provides the correct scenario on the signal controlled by the TB
    create_scenario : process
    begin
        wait for 50 ns;

        -- Signal initialization and reset of the component
        tb_start <= '0';
        tb_add <= (others=>'0');
        tb_k   <= (others=>'0');
        tb_rst <= '1';
        
        -- Wait some time for the component to reset...
        wait for 50 ns;
        
        tb_rst <= '0';
        memory_control <= '0';  -- Memory controlled by the testbench
        
        wait until falling_edge(tb_clk); -- Skew the testbench transitions with respect to the clock

        -- Configure the memory        
        for i in 0 to SCENARIO_LENGTH*2-1 loop
            init_o_mem_addr<= std_logic_vector(to_unsigned(SCENARIO_ADDRESS+i, 16));
            init_o_mem_data<= std_logic_vector(to_unsigned(scenario_input(i),8));
            init_o_mem_en  <= '1';
            init_o_mem_we  <= '1';
            wait until rising_edge(tb_clk);   
        end loop;
        
        wait until falling_edge(tb_clk);

        memory_control <= '1';  -- Memory controlled by the component
        
        tb_add <= std_logic_vector(to_unsigned(SCENARIO_ADDRESS, 16));
        tb_k   <= std_logic_vector(to_unsigned(SCENARIO_LENGTH, 10));
        
        tb_start <= '1';

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        wait for 5 ns;
        
        tb_start <= '0';
        
        wait;
        
    end process;

    -- Process without sensitivity list designed to test the actual component.
    test_routine : process
    begin

        wait until tb_rst = '1';
        wait for 25 ns;
        assert tb_done = '0' report "TEST FALLITO o_done !=0 during reset" severity failure;
        wait until tb_rst = '0';

        wait until falling_edge(tb_clk);
        assert tb_done = '0' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        
        wait until rising_edge(tb_start);

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        assert tb_o_mem_en = '0' or tb_o_mem_we = '0' report "TEST FALLITO o_mem_en !=0 memory should not be written after done." severity failure;

        for i in 0 to SCENARIO_LENGTH*2-1 loop
            assert RAM(SCENARIO_ADDRESS+i) = std_logic_vector(to_unsigned(scenario_full(i),8)) report "TEST FALLITO @ OFFSET=" & integer'image(i) & " expected= " & integer'image(scenario_full(i)) & " actual=" & integer'image(to_integer(unsigned(RAM(i)))) severity failure;
        end loop;

        wait until falling_edge(tb_start);
        assert tb_done = '1' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        wait until falling_edge(tb_done);

        assert false report "Simulation Ended! TEST PASSATO (EXAMPLE)" severity failure;
    end process;

end architecture;
