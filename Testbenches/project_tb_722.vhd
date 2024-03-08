-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_722 is
end project_tb_722;

architecture project_tb_arch_722 of project_tb_722 is
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

constant SCENARIO_LENGTH : integer := 225;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (202,0,190,0,243,0,128,0,169,0,0,0,175,0,174,0,141,0,39,0,50,0,0,0,75,0,0,0,223,0,164,0,119,0,238,0,51,0,125,0,109,0,0,0,78,0,3,0,164,0,0,0,79,0,218,0,152,0,61,0,36,0,18,0,1,0,69,0,93,0,162,0,21,0,24,0,248,0,0,0,253,0,0,0,0,0,0,0,168,0,135,0,14,0,220,0,53,0,4,0,94,0,44,0,0,0,12,0,142,0,138,0,0,0,0,0,236,0,0,0,161,0,180,0,171,0,237,0,110,0,0,0,137,0,0,0,248,0,0,0,0,0,216,0,113,0,26,0,115,0,0,0,66,0,0,0,236,0,222,0,49,0,178,0,62,0,183,0,26,0,171,0,37,0,80,0,175,0,3,0,65,0,17,0,189,0,139,0,41,0,0,0,63,0,188,0,80,0,172,0,131,0,49,0,246,0,0,0,202,0,36,0,228,0,0,0,182,0,122,0,165,0,116,0,0,0,242,0,228,0,51,0,251,0,0,0,0,0,16,0,172,0,253,0,86,0,0,0,28,0,190,0,0,0,21,0,163,0,1,0,0,0,0,0,78,0,12,0,80,0,195,0,152,0,97,0,24,0,158,0,0,0,0,0,221,0,91,0,0,0,95,0,19,0,0,0,174,0,48,0,18,0,3,0,217,0,0,0,193,0,41,0,35,0,0,0,150,0,0,0,152,0,249,0,73,0,123,0,196,0,107,0,142,0,0,0,91,0,171,0,151,0,21,0,99,0,123,0,0,0,0,0,15,0,221,0,18,0,0,0,73,0,0,0,55,0,0,0,0,0,66,0,7,0,242,0,139,0,0,0,225,0,249,0,156,0,0,0,0,0,0,0,124,0,145,0,0,0,220,0,24,0,0,0,91,0,207,0,0,0,185,0,90,0,15,0,0,0,174,0,168,0,225,0,0,0,217,0,40,0,158,0,79,0,158,0,0,0,211,0,131,0,92,0,0,0,157,0,252,0);
signal scenario_full  : scenario_type := (202,31,190,31,243,31,128,31,169,31,169,30,175,31,174,31,141,31,39,31,50,31,50,30,75,31,75,30,223,31,164,31,119,31,238,31,51,31,125,31,109,31,109,30,78,31,3,31,164,31,164,30,79,31,218,31,152,31,61,31,36,31,18,31,1,31,69,31,93,31,162,31,21,31,24,31,248,31,248,30,253,31,253,30,253,29,253,28,168,31,135,31,14,31,220,31,53,31,4,31,94,31,44,31,44,30,12,31,142,31,138,31,138,30,138,29,236,31,236,30,161,31,180,31,171,31,237,31,110,31,110,30,137,31,137,30,248,31,248,30,248,29,216,31,113,31,26,31,115,31,115,30,66,31,66,30,236,31,222,31,49,31,178,31,62,31,183,31,26,31,171,31,37,31,80,31,175,31,3,31,65,31,17,31,189,31,139,31,41,31,41,30,63,31,188,31,80,31,172,31,131,31,49,31,246,31,246,30,202,31,36,31,228,31,228,30,182,31,122,31,165,31,116,31,116,30,242,31,228,31,51,31,251,31,251,30,251,29,16,31,172,31,253,31,86,31,86,30,28,31,190,31,190,30,21,31,163,31,1,31,1,30,1,29,78,31,12,31,80,31,195,31,152,31,97,31,24,31,158,31,158,30,158,29,221,31,91,31,91,30,95,31,19,31,19,30,174,31,48,31,18,31,3,31,217,31,217,30,193,31,41,31,35,31,35,30,150,31,150,30,152,31,249,31,73,31,123,31,196,31,107,31,142,31,142,30,91,31,171,31,151,31,21,31,99,31,123,31,123,30,123,29,15,31,221,31,18,31,18,30,73,31,73,30,55,31,55,30,55,29,66,31,7,31,242,31,139,31,139,30,225,31,249,31,156,31,156,30,156,29,156,28,124,31,145,31,145,30,220,31,24,31,24,30,91,31,207,31,207,30,185,31,90,31,15,31,15,30,174,31,168,31,225,31,225,30,217,31,40,31,158,31,79,31,158,31,158,30,211,31,131,31,92,31,92,30,157,31,252,31);

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
