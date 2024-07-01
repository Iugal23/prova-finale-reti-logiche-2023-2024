-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_831 is
end project_tb_831;

architecture project_tb_arch_831 of project_tb_831 is
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

constant SCENARIO_LENGTH : integer := 274;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (46,0,7,0,59,0,234,0,236,0,255,0,4,0,41,0,40,0,137,0,106,0,70,0,99,0,139,0,178,0,33,0,155,0,97,0,206,0,146,0,0,0,72,0,173,0,0,0,181,0,48,0,173,0,130,0,165,0,0,0,0,0,10,0,191,0,16,0,0,0,238,0,1,0,189,0,227,0,244,0,70,0,243,0,226,0,236,0,0,0,87,0,224,0,76,0,2,0,227,0,154,0,132,0,26,0,223,0,0,0,207,0,121,0,47,0,0,0,229,0,169,0,147,0,73,0,124,0,31,0,117,0,192,0,254,0,173,0,241,0,151,0,207,0,82,0,57,0,107,0,0,0,0,0,242,0,175,0,0,0,156,0,106,0,228,0,0,0,97,0,23,0,95,0,52,0,148,0,0,0,24,0,49,0,229,0,137,0,112,0,0,0,0,0,160,0,0,0,0,0,0,0,213,0,0,0,40,0,67,0,1,0,207,0,238,0,145,0,0,0,0,0,154,0,20,0,139,0,251,0,126,0,3,0,135,0,81,0,94,0,0,0,0,0,0,0,181,0,0,0,45,0,0,0,222,0,120,0,219,0,239,0,89,0,37,0,20,0,11,0,60,0,0,0,0,0,79,0,205,0,62,0,56,0,0,0,129,0,89,0,8,0,230,0,0,0,33,0,0,0,227,0,101,0,167,0,166,0,12,0,225,0,3,0,0,0,166,0,251,0,253,0,0,0,140,0,21,0,81,0,0,0,117,0,43,0,35,0,0,0,84,0,239,0,215,0,146,0,0,0,229,0,174,0,164,0,13,0,0,0,19,0,230,0,59,0,0,0,93,0,0,0,249,0,22,0,158,0,79,0,60,0,85,0,0,0,43,0,82,0,1,0,0,0,0,0,46,0,0,0,118,0,239,0,0,0,81,0,176,0,164,0,236,0,29,0,154,0,156,0,14,0,0,0,114,0,246,0,131,0,244,0,123,0,27,0,167,0,129,0,54,0,204,0,136,0,65,0,249,0,212,0,221,0,239,0,147,0,160,0,0,0,113,0,119,0,65,0,162,0,190,0,0,0,80,0,137,0,59,0,106,0,44,0,20,0,0,0,234,0,201,0,212,0,206,0,35,0,0,0,93,0,11,0,250,0,171,0,25,0,0,0,92,0,104,0,0,0,125,0,244,0,36,0,0,0,52,0,159,0,21,0,0,0,168,0,177,0,26,0,109,0,0,0,164,0,0,0);
signal scenario_full  : scenario_type := (46,31,7,31,59,31,234,31,236,31,255,31,4,31,41,31,40,31,137,31,106,31,70,31,99,31,139,31,178,31,33,31,155,31,97,31,206,31,146,31,146,30,72,31,173,31,173,30,181,31,48,31,173,31,130,31,165,31,165,30,165,29,10,31,191,31,16,31,16,30,238,31,1,31,189,31,227,31,244,31,70,31,243,31,226,31,236,31,236,30,87,31,224,31,76,31,2,31,227,31,154,31,132,31,26,31,223,31,223,30,207,31,121,31,47,31,47,30,229,31,169,31,147,31,73,31,124,31,31,31,117,31,192,31,254,31,173,31,241,31,151,31,207,31,82,31,57,31,107,31,107,30,107,29,242,31,175,31,175,30,156,31,106,31,228,31,228,30,97,31,23,31,95,31,52,31,148,31,148,30,24,31,49,31,229,31,137,31,112,31,112,30,112,29,160,31,160,30,160,29,160,28,213,31,213,30,40,31,67,31,1,31,207,31,238,31,145,31,145,30,145,29,154,31,20,31,139,31,251,31,126,31,3,31,135,31,81,31,94,31,94,30,94,29,94,28,181,31,181,30,45,31,45,30,222,31,120,31,219,31,239,31,89,31,37,31,20,31,11,31,60,31,60,30,60,29,79,31,205,31,62,31,56,31,56,30,129,31,89,31,8,31,230,31,230,30,33,31,33,30,227,31,101,31,167,31,166,31,12,31,225,31,3,31,3,30,166,31,251,31,253,31,253,30,140,31,21,31,81,31,81,30,117,31,43,31,35,31,35,30,84,31,239,31,215,31,146,31,146,30,229,31,174,31,164,31,13,31,13,30,19,31,230,31,59,31,59,30,93,31,93,30,249,31,22,31,158,31,79,31,60,31,85,31,85,30,43,31,82,31,1,31,1,30,1,29,46,31,46,30,118,31,239,31,239,30,81,31,176,31,164,31,236,31,29,31,154,31,156,31,14,31,14,30,114,31,246,31,131,31,244,31,123,31,27,31,167,31,129,31,54,31,204,31,136,31,65,31,249,31,212,31,221,31,239,31,147,31,160,31,160,30,113,31,119,31,65,31,162,31,190,31,190,30,80,31,137,31,59,31,106,31,44,31,20,31,20,30,234,31,201,31,212,31,206,31,35,31,35,30,93,31,11,31,250,31,171,31,25,31,25,30,92,31,104,31,104,30,125,31,244,31,36,31,36,30,52,31,159,31,21,31,21,30,168,31,177,31,26,31,109,31,109,30,164,31,164,30);

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
