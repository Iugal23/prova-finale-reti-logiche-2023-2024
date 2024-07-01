-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_391 is
end project_tb_391;

architecture project_tb_arch_391 of project_tb_391 is
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

constant SCENARIO_LENGTH : integer := 290;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (140,0,189,0,154,0,202,0,0,0,109,0,0,0,42,0,49,0,0,0,149,0,109,0,0,0,235,0,97,0,243,0,81,0,142,0,58,0,205,0,243,0,246,0,0,0,53,0,39,0,54,0,0,0,201,0,45,0,0,0,12,0,105,0,248,0,145,0,139,0,83,0,73,0,141,0,230,0,0,0,185,0,74,0,210,0,157,0,44,0,54,0,35,0,42,0,148,0,102,0,69,0,186,0,0,0,0,0,0,0,161,0,7,0,17,0,161,0,132,0,201,0,238,0,117,0,33,0,45,0,18,0,189,0,227,0,188,0,237,0,225,0,166,0,45,0,29,0,255,0,0,0,203,0,228,0,22,0,172,0,7,0,226,0,0,0,0,0,56,0,0,0,124,0,248,0,0,0,152,0,249,0,5,0,179,0,31,0,108,0,34,0,86,0,135,0,0,0,194,0,26,0,131,0,41,0,0,0,150,0,60,0,224,0,106,0,0,0,136,0,171,0,0,0,122,0,79,0,197,0,194,0,31,0,244,0,6,0,0,0,0,0,170,0,85,0,44,0,160,0,141,0,116,0,0,0,0,0,144,0,207,0,152,0,0,0,126,0,13,0,205,0,87,0,83,0,198,0,41,0,0,0,190,0,43,0,0,0,125,0,63,0,35,0,52,0,2,0,74,0,172,0,67,0,0,0,229,0,32,0,25,0,142,0,0,0,0,0,19,0,226,0,166,0,0,0,9,0,169,0,22,0,0,0,207,0,69,0,215,0,233,0,25,0,6,0,0,0,98,0,71,0,46,0,231,0,143,0,142,0,0,0,208,0,162,0,0,0,0,0,236,0,0,0,224,0,126,0,95,0,55,0,0,0,0,0,113,0,23,0,227,0,199,0,0,0,170,0,226,0,0,0,0,0,29,0,0,0,129,0,221,0,0,0,93,0,29,0,139,0,172,0,163,0,254,0,194,0,43,0,0,0,174,0,85,0,229,0,219,0,105,0,218,0,235,0,171,0,113,0,232,0,66,0,180,0,97,0,127,0,0,0,18,0,220,0,88,0,126,0,141,0,9,0,117,0,229,0,0,0,0,0,97,0,202,0,0,0,14,0,252,0,32,0,73,0,0,0,81,0,63,0,28,0,14,0,198,0,147,0,0,0,234,0,137,0,45,0,70,0,34,0,54,0,70,0,0,0,137,0,240,0,115,0,95,0,0,0,143,0,245,0,88,0,148,0,36,0,53,0,116,0,0,0,135,0,40,0,0,0,0,0,182,0,102,0,158,0,136,0,216,0,230,0,47,0,88,0,101,0);
signal scenario_full  : scenario_type := (140,31,189,31,154,31,202,31,202,30,109,31,109,30,42,31,49,31,49,30,149,31,109,31,109,30,235,31,97,31,243,31,81,31,142,31,58,31,205,31,243,31,246,31,246,30,53,31,39,31,54,31,54,30,201,31,45,31,45,30,12,31,105,31,248,31,145,31,139,31,83,31,73,31,141,31,230,31,230,30,185,31,74,31,210,31,157,31,44,31,54,31,35,31,42,31,148,31,102,31,69,31,186,31,186,30,186,29,186,28,161,31,7,31,17,31,161,31,132,31,201,31,238,31,117,31,33,31,45,31,18,31,189,31,227,31,188,31,237,31,225,31,166,31,45,31,29,31,255,31,255,30,203,31,228,31,22,31,172,31,7,31,226,31,226,30,226,29,56,31,56,30,124,31,248,31,248,30,152,31,249,31,5,31,179,31,31,31,108,31,34,31,86,31,135,31,135,30,194,31,26,31,131,31,41,31,41,30,150,31,60,31,224,31,106,31,106,30,136,31,171,31,171,30,122,31,79,31,197,31,194,31,31,31,244,31,6,31,6,30,6,29,170,31,85,31,44,31,160,31,141,31,116,31,116,30,116,29,144,31,207,31,152,31,152,30,126,31,13,31,205,31,87,31,83,31,198,31,41,31,41,30,190,31,43,31,43,30,125,31,63,31,35,31,52,31,2,31,74,31,172,31,67,31,67,30,229,31,32,31,25,31,142,31,142,30,142,29,19,31,226,31,166,31,166,30,9,31,169,31,22,31,22,30,207,31,69,31,215,31,233,31,25,31,6,31,6,30,98,31,71,31,46,31,231,31,143,31,142,31,142,30,208,31,162,31,162,30,162,29,236,31,236,30,224,31,126,31,95,31,55,31,55,30,55,29,113,31,23,31,227,31,199,31,199,30,170,31,226,31,226,30,226,29,29,31,29,30,129,31,221,31,221,30,93,31,29,31,139,31,172,31,163,31,254,31,194,31,43,31,43,30,174,31,85,31,229,31,219,31,105,31,218,31,235,31,171,31,113,31,232,31,66,31,180,31,97,31,127,31,127,30,18,31,220,31,88,31,126,31,141,31,9,31,117,31,229,31,229,30,229,29,97,31,202,31,202,30,14,31,252,31,32,31,73,31,73,30,81,31,63,31,28,31,14,31,198,31,147,31,147,30,234,31,137,31,45,31,70,31,34,31,54,31,70,31,70,30,137,31,240,31,115,31,95,31,95,30,143,31,245,31,88,31,148,31,36,31,53,31,116,31,116,30,135,31,40,31,40,30,40,29,182,31,102,31,158,31,136,31,216,31,230,31,47,31,88,31,101,31);

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
