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

constant SCENARIO_LENGTH : integer := 528;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (6,0,0,0,0,0,0,0,240,0,65,0,60,0,0,0,150,0,251,0,41,0,0,0,18,0,50,0,105,0,153,0,102,0,55,0,63,0,122,0,140,0,98,0,255,0,196,0,245,0,166,0,212,0,28,0,154,0,126,0,57,0,176,0,243,0,144,0,0,0,56,0,160,0,21,0,53,0,70,0,245,0,40,0,142,0,134,0,102,0,68,0,230,0,233,0,122,0,166,0,0,0,149,0,146,0,55,0,0,0,171,0,211,0,72,0,0,0,78,0,2,0,9,0,45,0,55,0,135,0,32,0,46,0,243,0,199,0,8,0,237,0,236,0,254,0,47,0,165,0,54,0,253,0,40,0,154,0,11,0,39,0,201,0,5,0,0,0,127,0,0,0,67,0,242,0,154,0,16,0,143,0,49,0,16,0,200,0,0,0,0,0,0,0,239,0,211,0,0,0,0,0,0,0,253,0,163,0,96,0,197,0,129,0,98,0,135,0,241,0,214,0,5,0,243,0,0,0,21,0,215,0,160,0,5,0,56,0,77,0,177,0,172,0,0,0,37,0,18,0,254,0,0,0,12,0,152,0,201,0,34,0,224,0,117,0,249,0,73,0,125,0,35,0,0,0,1,0,158,0,183,0,47,0,37,0,0,0,0,0,134,0,102,0,221,0,204,0,70,0,0,0,142,0,41,0,68,0,122,0,240,0,142,0,33,0,203,0,206,0,0,0,29,0,219,0,106,0,15,0,104,0,80,0,14,0,176,0,183,0,102,0,9,0,73,0,129,0,0,0,184,0,168,0,236,0,226,0,188,0,101,0,7,0,131,0,114,0,232,0,0,0,19,0,74,0,0,0,229,0,237,0,40,0,156,0,0,0,110,0,0,0,139,0,159,0,136,0,105,0,38,0,133,0,84,0,186,0,208,0,249,0,174,0,0,0,0,0,0,0,227,0,23,0,0,0,155,0,91,0,248,0,249,0,12,0,130,0,38,0,109,0,17,0,26,0,53,0,233,0,22,0,0,0,103,0,194,0,230,0,31,0,38,0,0,0,213,0,83,0,99,0,200,0,35,0,155,0,179,0,56,0,61,0,224,0,210,0,56,0,152,0,163,0,87,0,77,0,228,0,253,0,0,0,3,0,0,0,172,0,91,0,193,0,0,0,206,0,197,0,0,0,61,0,61,0,0,0,195,0,121,0,0,0,218,0,226,0,0,0,123,0,168,0,56,0,220,0,0,0,206,0,202,0,69,0,180,0,57,0,37,0,176,0,152,0,0,0,8,0,44,0,86,0,26,0,0,0,73,0,176,0,166,0,158,0,254,0,170,0,98,0,34,0,73,0,0,0,0,0,172,0,247,0,16,0,47,0,0,0,43,0,132,0,227,0,0,0,181,0,179,0,79,0,23,0,222,0,232,0,223,0,0,0,50,0,50,0,27,0,7,0,248,0,87,0,64,0,25,0,145,0,0,0,93,0,0,0,82,0,44,0,160,0,36,0,0,0,88,0,58,0,140,0,247,0,161,0,10,0,237,0,214,0,89,0,0,0,233,0,234,0,155,0,143,0,107,0,0,0,0,0,107,0,0,0,69,0,58,0,29,0,98,0,68,0,233,0,60,0,237,0,41,0,0,0,84,0,221,0,89,0,121,0,201,0,87,0,198,0,203,0,49,0,184,0,192,0,254,0,199,0,174,0,100,0,4,0,102,0,12,0,42,0,185,0,0,0,55,0,0,0,128,0,0,0,0,0,94,0,54,0,0,0,14,0,0,0,9,0,124,0,111,0,0,0,76,0,0,0,227,0,182,0,221,0,166,0,113,0,199,0,243,0,0,0,83,0,78,0,161,0,29,0,197,0,146,0,0,0,205,0,182,0,125,0,190,0,193,0,226,0,56,0,146,0,10,0,65,0,206,0,9,0,42,0,10,0,246,0,0,0,150,0,106,0,98,0,58,0,249,0,187,0,163,0,201,0,244,0,248,0,128,0,229,0,189,0,53,0,179,0,109,0,196,0,0,0,173,0,0,0,183,0,49,0,0,0,156,0,133,0,199,0,16,0,0,0,97,0,176,0,107,0,205,0,102,0,0,0,0,0,193,0,118,0,163,0,224,0,45,0,231,0,167,0,0,0,236,0,32,0,51,0,0,0,161,0,44,0,141,0,92,0,52,0,148,0,33,0,0,0,64,0,0,0,170,0,186,0,0,0,4,0,0,0,37,0,207,0,233,0,0,0,240,0,209,0,174,0,220,0,28,0,130,0,191,0,244,0,190,0,209,0,155,0,105,0,0,0,156,0,238,0,0,0,233,0,138,0,213,0,231,0,0,0,101,0,61,0,111,0,166,0,0,0,182,0,164,0,0,0,175,0,91,0);
signal scenario_full  : scenario_type := (6,31,6,30,6,29,6,28,240,31,65,31,60,31,60,30,150,31,251,31,41,31,41,30,18,31,50,31,105,31,153,31,102,31,55,31,63,31,122,31,140,31,98,31,255,31,196,31,245,31,166,31,212,31,28,31,154,31,126,31,57,31,176,31,243,31,144,31,144,30,56,31,160,31,21,31,53,31,70,31,245,31,40,31,142,31,134,31,102,31,68,31,230,31,233,31,122,31,166,31,166,30,149,31,146,31,55,31,55,30,171,31,211,31,72,31,72,30,78,31,2,31,9,31,45,31,55,31,135,31,32,31,46,31,243,31,199,31,8,31,237,31,236,31,254,31,47,31,165,31,54,31,253,31,40,31,154,31,11,31,39,31,201,31,5,31,5,30,127,31,127,30,67,31,242,31,154,31,16,31,143,31,49,31,16,31,200,31,200,30,200,29,200,28,239,31,211,31,211,30,211,29,211,28,253,31,163,31,96,31,197,31,129,31,98,31,135,31,241,31,214,31,5,31,243,31,243,30,21,31,215,31,160,31,5,31,56,31,77,31,177,31,172,31,172,30,37,31,18,31,254,31,254,30,12,31,152,31,201,31,34,31,224,31,117,31,249,31,73,31,125,31,35,31,35,30,1,31,158,31,183,31,47,31,37,31,37,30,37,29,134,31,102,31,221,31,204,31,70,31,70,30,142,31,41,31,68,31,122,31,240,31,142,31,33,31,203,31,206,31,206,30,29,31,219,31,106,31,15,31,104,31,80,31,14,31,176,31,183,31,102,31,9,31,73,31,129,31,129,30,184,31,168,31,236,31,226,31,188,31,101,31,7,31,131,31,114,31,232,31,232,30,19,31,74,31,74,30,229,31,237,31,40,31,156,31,156,30,110,31,110,30,139,31,159,31,136,31,105,31,38,31,133,31,84,31,186,31,208,31,249,31,174,31,174,30,174,29,174,28,227,31,23,31,23,30,155,31,91,31,248,31,249,31,12,31,130,31,38,31,109,31,17,31,26,31,53,31,233,31,22,31,22,30,103,31,194,31,230,31,31,31,38,31,38,30,213,31,83,31,99,31,200,31,35,31,155,31,179,31,56,31,61,31,224,31,210,31,56,31,152,31,163,31,87,31,77,31,228,31,253,31,253,30,3,31,3,30,172,31,91,31,193,31,193,30,206,31,197,31,197,30,61,31,61,31,61,30,195,31,121,31,121,30,218,31,226,31,226,30,123,31,168,31,56,31,220,31,220,30,206,31,202,31,69,31,180,31,57,31,37,31,176,31,152,31,152,30,8,31,44,31,86,31,26,31,26,30,73,31,176,31,166,31,158,31,254,31,170,31,98,31,34,31,73,31,73,30,73,29,172,31,247,31,16,31,47,31,47,30,43,31,132,31,227,31,227,30,181,31,179,31,79,31,23,31,222,31,232,31,223,31,223,30,50,31,50,31,27,31,7,31,248,31,87,31,64,31,25,31,145,31,145,30,93,31,93,30,82,31,44,31,160,31,36,31,36,30,88,31,58,31,140,31,247,31,161,31,10,31,237,31,214,31,89,31,89,30,233,31,234,31,155,31,143,31,107,31,107,30,107,29,107,31,107,30,69,31,58,31,29,31,98,31,68,31,233,31,60,31,237,31,41,31,41,30,84,31,221,31,89,31,121,31,201,31,87,31,198,31,203,31,49,31,184,31,192,31,254,31,199,31,174,31,100,31,4,31,102,31,12,31,42,31,185,31,185,30,55,31,55,30,128,31,128,30,128,29,94,31,54,31,54,30,14,31,14,30,9,31,124,31,111,31,111,30,76,31,76,30,227,31,182,31,221,31,166,31,113,31,199,31,243,31,243,30,83,31,78,31,161,31,29,31,197,31,146,31,146,30,205,31,182,31,125,31,190,31,193,31,226,31,56,31,146,31,10,31,65,31,206,31,9,31,42,31,10,31,246,31,246,30,150,31,106,31,98,31,58,31,249,31,187,31,163,31,201,31,244,31,248,31,128,31,229,31,189,31,53,31,179,31,109,31,196,31,196,30,173,31,173,30,183,31,49,31,49,30,156,31,133,31,199,31,16,31,16,30,97,31,176,31,107,31,205,31,102,31,102,30,102,29,193,31,118,31,163,31,224,31,45,31,231,31,167,31,167,30,236,31,32,31,51,31,51,30,161,31,44,31,141,31,92,31,52,31,148,31,33,31,33,30,64,31,64,30,170,31,186,31,186,30,4,31,4,30,37,31,207,31,233,31,233,30,240,31,209,31,174,31,220,31,28,31,130,31,191,31,244,31,190,31,209,31,155,31,105,31,105,30,156,31,238,31,238,30,233,31,138,31,213,31,231,31,231,30,101,31,61,31,111,31,166,31,166,30,182,31,164,31,164,30,175,31,91,31);

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
