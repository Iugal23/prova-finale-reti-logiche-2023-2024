-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_89 is
end project_tb_89;

architecture project_tb_arch_89 of project_tb_89 is
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

constant SCENARIO_LENGTH : integer := 686;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (208,0,46,0,33,0,0,0,189,0,102,0,40,0,86,0,0,0,36,0,47,0,85,0,236,0,106,0,250,0,134,0,200,0,128,0,41,0,135,0,118,0,234,0,30,0,0,0,0,0,254,0,91,0,0,0,2,0,79,0,212,0,112,0,0,0,168,0,80,0,240,0,38,0,75,0,2,0,104,0,170,0,0,0,0,0,136,0,26,0,191,0,17,0,251,0,177,0,0,0,0,0,55,0,248,0,1,0,235,0,249,0,163,0,248,0,13,0,162,0,0,0,44,0,0,0,240,0,66,0,230,0,188,0,0,0,65,0,57,0,44,0,216,0,153,0,89,0,132,0,78,0,3,0,0,0,0,0,73,0,186,0,234,0,35,0,218,0,0,0,74,0,114,0,147,0,208,0,147,0,0,0,15,0,0,0,239,0,0,0,0,0,196,0,229,0,0,0,0,0,104,0,48,0,0,0,130,0,134,0,0,0,0,0,13,0,181,0,47,0,28,0,191,0,167,0,91,0,254,0,8,0,238,0,148,0,78,0,0,0,0,0,9,0,90,0,38,0,66,0,0,0,59,0,0,0,0,0,25,0,140,0,0,0,118,0,177,0,71,0,187,0,81,0,174,0,180,0,80,0,226,0,47,0,54,0,54,0,135,0,27,0,38,0,98,0,63,0,55,0,43,0,100,0,0,0,252,0,45,0,48,0,0,0,236,0,11,0,240,0,244,0,59,0,25,0,242,0,35,0,25,0,201,0,45,0,241,0,140,0,35,0,110,0,110,0,205,0,187,0,0,0,0,0,99,0,208,0,111,0,237,0,124,0,56,0,0,0,176,0,158,0,73,0,49,0,187,0,96,0,218,0,242,0,0,0,1,0,220,0,114,0,176,0,36,0,66,0,0,0,65,0,136,0,189,0,80,0,148,0,0,0,198,0,193,0,159,0,126,0,18,0,0,0,81,0,211,0,45,0,244,0,16,0,181,0,244,0,0,0,82,0,0,0,52,0,96,0,10,0,1,0,144,0,0,0,24,0,96,0,0,0,129,0,0,0,183,0,133,0,121,0,0,0,249,0,178,0,186,0,14,0,0,0,0,0,0,0,0,0,71,0,219,0,180,0,247,0,160,0,0,0,142,0,80,0,164,0,32,0,68,0,181,0,45,0,148,0,152,0,112,0,0,0,25,0,0,0,97,0,249,0,65,0,141,0,0,0,217,0,119,0,239,0,8,0,184,0,220,0,65,0,26,0,11,0,28,0,49,0,203,0,216,0,185,0,24,0,52,0,242,0,44,0,20,0,72,0,0,0,17,0,97,0,0,0,89,0,0,0,171,0,218,0,6,0,203,0,229,0,196,0,148,0,195,0,63,0,182,0,0,0,0,0,143,0,244,0,148,0,9,0,166,0,147,0,50,0,55,0,213,0,92,0,238,0,0,0,58,0,0,0,0,0,65,0,205,0,0,0,33,0,0,0,177,0,220,0,248,0,234,0,252,0,0,0,189,0,108,0,51,0,207,0,20,0,0,0,67,0,20,0,72,0,138,0,0,0,0,0,146,0,81,0,25,0,0,0,4,0,137,0,84,0,0,0,252,0,100,0,24,0,48,0,0,0,186,0,0,0,207,0,131,0,86,0,34,0,97,0,174,0,158,0,79,0,187,0,0,0,132,0,58,0,184,0,78,0,2,0,199,0,133,0,19,0,138,0,0,0,72,0,214,0,102,0,78,0,133,0,165,0,197,0,192,0,0,0,124,0,70,0,116,0,0,0,106,0,92,0,233,0,0,0,235,0,121,0,89,0,135,0,0,0,0,0,227,0,0,0,70,0,252,0,0,0,31,0,0,0,164,0,25,0,73,0,219,0,253,0,139,0,0,0,148,0,227,0,113,0,213,0,212,0,122,0,172,0,181,0,228,0,70,0,42,0,61,0,63,0,179,0,67,0,0,0,145,0,74,0,254,0,114,0,56,0,242,0,49,0,134,0,0,0,231,0,71,0,72,0,69,0,191,0,0,0,147,0,0,0,43,0,140,0,0,0,216,0,255,0,143,0,99,0,0,0,233,0,0,0,253,0,144,0,123,0,204,0,233,0,194,0,138,0,122,0,51,0,72,0,222,0,66,0,12,0,136,0,0,0,154,0,0,0,170,0,49,0,91,0,0,0,0,0,160,0,213,0,0,0,0,0,49,0,76,0,74,0,177,0,149,0,175,0,73,0,0,0,252,0,13,0,0,0,102,0,138,0,135,0,124,0,49,0,29,0,207,0,83,0,0,0,0,0,115,0,153,0,0,0,113,0,16,0,170,0,41,0,0,0,0,0,250,0,0,0,0,0,29,0,64,0,11,0,64,0,211,0,14,0,0,0,87,0,0,0,105,0,239,0,50,0,0,0,208,0,0,0,147,0,99,0,169,0,174,0,155,0,31,0,5,0,0,0,113,0,113,0,148,0,172,0,35,0,3,0,238,0,13,0,0,0,0,0,88,0,180,0,130,0,0,0,0,0,6,0,50,0,90,0,134,0,94,0,39,0,71,0,67,0,214,0,239,0,0,0,0,0,209,0,13,0,187,0,41,0,146,0,79,0,171,0,109,0,138,0,171,0,34,0,106,0,187,0,188,0,0,0,141,0,10,0,202,0,245,0,0,0,93,0,9,0,243,0,179,0,146,0,25,0,136,0,146,0,155,0,0,0,26,0,100,0,49,0,250,0,25,0,0,0,220,0,79,0,148,0,12,0,0,0,26,0,188,0,245,0,140,0,246,0,82,0,31,0,144,0,83,0,56,0,215,0,60,0,237,0,0,0,79,0,115,0,40,0,221,0,0,0,221,0,0,0,0,0,158,0,0,0,0,0,0,0,226,0,9,0,170,0,42,0,124,0,0,0,58,0,9,0,150,0,98,0,0,0,150,0,49,0,242,0,25,0,68,0,194,0,140,0,0,0,190,0,154,0,0,0,163,0,0,0,32,0,161,0,0,0,3,0,118,0,165,0,167,0,69,0,76,0,203,0,64,0,99,0,117,0,116,0,60,0,0,0,0,0,0,0,31,0,37,0,33,0,154,0,188,0,79,0,58,0,0,0);
signal scenario_full  : scenario_type := (208,31,46,31,33,31,33,30,189,31,102,31,40,31,86,31,86,30,36,31,47,31,85,31,236,31,106,31,250,31,134,31,200,31,128,31,41,31,135,31,118,31,234,31,30,31,30,30,30,29,254,31,91,31,91,30,2,31,79,31,212,31,112,31,112,30,168,31,80,31,240,31,38,31,75,31,2,31,104,31,170,31,170,30,170,29,136,31,26,31,191,31,17,31,251,31,177,31,177,30,177,29,55,31,248,31,1,31,235,31,249,31,163,31,248,31,13,31,162,31,162,30,44,31,44,30,240,31,66,31,230,31,188,31,188,30,65,31,57,31,44,31,216,31,153,31,89,31,132,31,78,31,3,31,3,30,3,29,73,31,186,31,234,31,35,31,218,31,218,30,74,31,114,31,147,31,208,31,147,31,147,30,15,31,15,30,239,31,239,30,239,29,196,31,229,31,229,30,229,29,104,31,48,31,48,30,130,31,134,31,134,30,134,29,13,31,181,31,47,31,28,31,191,31,167,31,91,31,254,31,8,31,238,31,148,31,78,31,78,30,78,29,9,31,90,31,38,31,66,31,66,30,59,31,59,30,59,29,25,31,140,31,140,30,118,31,177,31,71,31,187,31,81,31,174,31,180,31,80,31,226,31,47,31,54,31,54,31,135,31,27,31,38,31,98,31,63,31,55,31,43,31,100,31,100,30,252,31,45,31,48,31,48,30,236,31,11,31,240,31,244,31,59,31,25,31,242,31,35,31,25,31,201,31,45,31,241,31,140,31,35,31,110,31,110,31,205,31,187,31,187,30,187,29,99,31,208,31,111,31,237,31,124,31,56,31,56,30,176,31,158,31,73,31,49,31,187,31,96,31,218,31,242,31,242,30,1,31,220,31,114,31,176,31,36,31,66,31,66,30,65,31,136,31,189,31,80,31,148,31,148,30,198,31,193,31,159,31,126,31,18,31,18,30,81,31,211,31,45,31,244,31,16,31,181,31,244,31,244,30,82,31,82,30,52,31,96,31,10,31,1,31,144,31,144,30,24,31,96,31,96,30,129,31,129,30,183,31,133,31,121,31,121,30,249,31,178,31,186,31,14,31,14,30,14,29,14,28,14,27,71,31,219,31,180,31,247,31,160,31,160,30,142,31,80,31,164,31,32,31,68,31,181,31,45,31,148,31,152,31,112,31,112,30,25,31,25,30,97,31,249,31,65,31,141,31,141,30,217,31,119,31,239,31,8,31,184,31,220,31,65,31,26,31,11,31,28,31,49,31,203,31,216,31,185,31,24,31,52,31,242,31,44,31,20,31,72,31,72,30,17,31,97,31,97,30,89,31,89,30,171,31,218,31,6,31,203,31,229,31,196,31,148,31,195,31,63,31,182,31,182,30,182,29,143,31,244,31,148,31,9,31,166,31,147,31,50,31,55,31,213,31,92,31,238,31,238,30,58,31,58,30,58,29,65,31,205,31,205,30,33,31,33,30,177,31,220,31,248,31,234,31,252,31,252,30,189,31,108,31,51,31,207,31,20,31,20,30,67,31,20,31,72,31,138,31,138,30,138,29,146,31,81,31,25,31,25,30,4,31,137,31,84,31,84,30,252,31,100,31,24,31,48,31,48,30,186,31,186,30,207,31,131,31,86,31,34,31,97,31,174,31,158,31,79,31,187,31,187,30,132,31,58,31,184,31,78,31,2,31,199,31,133,31,19,31,138,31,138,30,72,31,214,31,102,31,78,31,133,31,165,31,197,31,192,31,192,30,124,31,70,31,116,31,116,30,106,31,92,31,233,31,233,30,235,31,121,31,89,31,135,31,135,30,135,29,227,31,227,30,70,31,252,31,252,30,31,31,31,30,164,31,25,31,73,31,219,31,253,31,139,31,139,30,148,31,227,31,113,31,213,31,212,31,122,31,172,31,181,31,228,31,70,31,42,31,61,31,63,31,179,31,67,31,67,30,145,31,74,31,254,31,114,31,56,31,242,31,49,31,134,31,134,30,231,31,71,31,72,31,69,31,191,31,191,30,147,31,147,30,43,31,140,31,140,30,216,31,255,31,143,31,99,31,99,30,233,31,233,30,253,31,144,31,123,31,204,31,233,31,194,31,138,31,122,31,51,31,72,31,222,31,66,31,12,31,136,31,136,30,154,31,154,30,170,31,49,31,91,31,91,30,91,29,160,31,213,31,213,30,213,29,49,31,76,31,74,31,177,31,149,31,175,31,73,31,73,30,252,31,13,31,13,30,102,31,138,31,135,31,124,31,49,31,29,31,207,31,83,31,83,30,83,29,115,31,153,31,153,30,113,31,16,31,170,31,41,31,41,30,41,29,250,31,250,30,250,29,29,31,64,31,11,31,64,31,211,31,14,31,14,30,87,31,87,30,105,31,239,31,50,31,50,30,208,31,208,30,147,31,99,31,169,31,174,31,155,31,31,31,5,31,5,30,113,31,113,31,148,31,172,31,35,31,3,31,238,31,13,31,13,30,13,29,88,31,180,31,130,31,130,30,130,29,6,31,50,31,90,31,134,31,94,31,39,31,71,31,67,31,214,31,239,31,239,30,239,29,209,31,13,31,187,31,41,31,146,31,79,31,171,31,109,31,138,31,171,31,34,31,106,31,187,31,188,31,188,30,141,31,10,31,202,31,245,31,245,30,93,31,9,31,243,31,179,31,146,31,25,31,136,31,146,31,155,31,155,30,26,31,100,31,49,31,250,31,25,31,25,30,220,31,79,31,148,31,12,31,12,30,26,31,188,31,245,31,140,31,246,31,82,31,31,31,144,31,83,31,56,31,215,31,60,31,237,31,237,30,79,31,115,31,40,31,221,31,221,30,221,31,221,30,221,29,158,31,158,30,158,29,158,28,226,31,9,31,170,31,42,31,124,31,124,30,58,31,9,31,150,31,98,31,98,30,150,31,49,31,242,31,25,31,68,31,194,31,140,31,140,30,190,31,154,31,154,30,163,31,163,30,32,31,161,31,161,30,3,31,118,31,165,31,167,31,69,31,76,31,203,31,64,31,99,31,117,31,116,31,60,31,60,30,60,29,60,28,31,31,37,31,33,31,154,31,188,31,79,31,58,31,58,30);

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
