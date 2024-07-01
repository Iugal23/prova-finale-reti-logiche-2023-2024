-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_962 is
end project_tb_962;

architecture project_tb_arch_962 of project_tb_962 is
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

constant SCENARIO_LENGTH : integer := 283;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,228,0,230,0,69,0,129,0,0,0,0,0,8,0,94,0,0,0,11,0,248,0,101,0,195,0,49,0,128,0,48,0,0,0,69,0,139,0,0,0,179,0,0,0,198,0,53,0,35,0,0,0,118,0,30,0,0,0,20,0,47,0,0,0,0,0,168,0,0,0,134,0,5,0,186,0,0,0,107,0,0,0,121,0,154,0,60,0,233,0,219,0,0,0,112,0,0,0,53,0,105,0,101,0,215,0,126,0,66,0,235,0,0,0,139,0,88,0,0,0,239,0,209,0,198,0,37,0,59,0,139,0,0,0,213,0,0,0,118,0,249,0,130,0,205,0,86,0,0,0,64,0,80,0,171,0,0,0,148,0,0,0,0,0,211,0,57,0,0,0,110,0,0,0,205,0,130,0,0,0,255,0,0,0,249,0,45,0,0,0,31,0,0,0,9,0,0,0,102,0,84,0,0,0,0,0,0,0,0,0,29,0,58,0,69,0,80,0,135,0,236,0,206,0,99,0,54,0,164,0,236,0,31,0,252,0,0,0,2,0,37,0,57,0,14,0,136,0,197,0,160,0,125,0,0,0,65,0,0,0,63,0,141,0,8,0,200,0,0,0,75,0,0,0,108,0,151,0,65,0,1,0,55,0,0,0,4,0,48,0,36,0,129,0,43,0,169,0,107,0,114,0,108,0,168,0,253,0,129,0,0,0,81,0,188,0,0,0,2,0,0,0,0,0,208,0,79,0,0,0,205,0,0,0,4,0,103,0,118,0,113,0,70,0,26,0,0,0,186,0,47,0,7,0,59,0,119,0,179,0,40,0,111,0,94,0,123,0,0,0,0,0,84,0,215,0,0,0,0,0,106,0,89,0,177,0,55,0,100,0,190,0,213,0,0,0,95,0,60,0,0,0,229,0,115,0,251,0,80,0,0,0,187,0,145,0,206,0,199,0,148,0,182,0,173,0,127,0,0,0,104,0,40,0,0,0,19,0,232,0,0,0,0,0,13,0,21,0,65,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,25,0,171,0,0,0,197,0,249,0,214,0,102,0,69,0,12,0,0,0,53,0,0,0,120,0,177,0,208,0,18,0,43,0,115,0,50,0,218,0,247,0,0,0,0,0,0,0,0,0,0,0,211,0,182,0,217,0,74,0,91,0,21,0,97,0,212,0,66,0,210,0,173,0,175,0,220,0,115,0,73,0,193,0,90,0,168,0,0,0,115,0,219,0,0,0,193,0,0,0);
signal scenario_full  : scenario_type := (0,0,228,31,230,31,69,31,129,31,129,30,129,29,8,31,94,31,94,30,11,31,248,31,101,31,195,31,49,31,128,31,48,31,48,30,69,31,139,31,139,30,179,31,179,30,198,31,53,31,35,31,35,30,118,31,30,31,30,30,20,31,47,31,47,30,47,29,168,31,168,30,134,31,5,31,186,31,186,30,107,31,107,30,121,31,154,31,60,31,233,31,219,31,219,30,112,31,112,30,53,31,105,31,101,31,215,31,126,31,66,31,235,31,235,30,139,31,88,31,88,30,239,31,209,31,198,31,37,31,59,31,139,31,139,30,213,31,213,30,118,31,249,31,130,31,205,31,86,31,86,30,64,31,80,31,171,31,171,30,148,31,148,30,148,29,211,31,57,31,57,30,110,31,110,30,205,31,130,31,130,30,255,31,255,30,249,31,45,31,45,30,31,31,31,30,9,31,9,30,102,31,84,31,84,30,84,29,84,28,84,27,29,31,58,31,69,31,80,31,135,31,236,31,206,31,99,31,54,31,164,31,236,31,31,31,252,31,252,30,2,31,37,31,57,31,14,31,136,31,197,31,160,31,125,31,125,30,65,31,65,30,63,31,141,31,8,31,200,31,200,30,75,31,75,30,108,31,151,31,65,31,1,31,55,31,55,30,4,31,48,31,36,31,129,31,43,31,169,31,107,31,114,31,108,31,168,31,253,31,129,31,129,30,81,31,188,31,188,30,2,31,2,30,2,29,208,31,79,31,79,30,205,31,205,30,4,31,103,31,118,31,113,31,70,31,26,31,26,30,186,31,47,31,7,31,59,31,119,31,179,31,40,31,111,31,94,31,123,31,123,30,123,29,84,31,215,31,215,30,215,29,106,31,89,31,177,31,55,31,100,31,190,31,213,31,213,30,95,31,60,31,60,30,229,31,115,31,251,31,80,31,80,30,187,31,145,31,206,31,199,31,148,31,182,31,173,31,127,31,127,30,104,31,40,31,40,30,19,31,232,31,232,30,232,29,13,31,21,31,65,31,65,30,65,29,3,31,3,30,3,29,3,28,3,27,25,31,171,31,171,30,197,31,249,31,214,31,102,31,69,31,12,31,12,30,53,31,53,30,120,31,177,31,208,31,18,31,43,31,115,31,50,31,218,31,247,31,247,30,247,29,247,28,247,27,247,26,211,31,182,31,217,31,74,31,91,31,21,31,97,31,212,31,66,31,210,31,173,31,175,31,220,31,115,31,73,31,193,31,90,31,168,31,168,30,115,31,219,31,219,30,193,31,193,30);

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
