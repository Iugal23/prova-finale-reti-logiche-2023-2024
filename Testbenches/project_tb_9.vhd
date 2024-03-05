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

constant SCENARIO_LENGTH : integer := 227;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (143,0,36,0,247,0,206,0,0,0,232,0,217,0,106,0,130,0,0,0,228,0,240,0,195,0,57,0,13,0,0,0,142,0,81,0,0,0,0,0,92,0,226,0,82,0,0,0,171,0,47,0,0,0,138,0,146,0,220,0,0,0,45,0,0,0,255,0,105,0,244,0,163,0,24,0,207,0,0,0,241,0,118,0,0,0,61,0,0,0,0,0,0,0,228,0,16,0,0,0,163,0,0,0,0,0,0,0,158,0,0,0,103,0,126,0,50,0,79,0,61,0,144,0,0,0,252,0,218,0,126,0,87,0,230,0,136,0,190,0,32,0,171,0,205,0,203,0,0,0,0,0,0,0,52,0,16,0,188,0,0,0,0,0,236,0,30,0,136,0,16,0,140,0,90,0,50,0,247,0,93,0,197,0,223,0,0,0,84,0,68,0,124,0,0,0,190,0,0,0,217,0,178,0,225,0,0,0,0,0,176,0,203,0,0,0,174,0,117,0,239,0,173,0,202,0,118,0,173,0,233,0,0,0,155,0,238,0,202,0,108,0,215,0,0,0,114,0,189,0,99,0,0,0,0,0,253,0,144,0,199,0,205,0,240,0,160,0,146,0,74,0,14,0,75,0,0,0,232,0,177,0,20,0,42,0,252,0,34,0,0,0,235,0,246,0,168,0,164,0,152,0,73,0,5,0,35,0,139,0,0,0,107,0,161,0,227,0,227,0,0,0,196,0,185,0,101,0,133,0,94,0,51,0,0,0,77,0,61,0,236,0,0,0,0,0,82,0,51,0,115,0,58,0,129,0,183,0,212,0,36,0,154,0,100,0,0,0,186,0,247,0,125,0,77,0,84,0,245,0,79,0,174,0,0,0,0,0,116,0,233,0,189,0,124,0,0,0,0,0,23,0,0,0,3,0,180,0,81,0,124,0,192,0,90,0,198,0,241,0,126,0,9,0,249,0,176,0,32,0,0,0,173,0,0,0,128,0,0,0,0,0,150,0,87,0,42,0,201,0,0,0,90,0);
signal scenario_full  : scenario_type := (143,31,36,31,247,31,206,31,206,30,232,31,217,31,106,31,130,31,130,30,228,31,240,31,195,31,57,31,13,31,13,30,142,31,81,31,81,30,81,29,92,31,226,31,82,31,82,30,171,31,47,31,47,30,138,31,146,31,220,31,220,30,45,31,45,30,255,31,105,31,244,31,163,31,24,31,207,31,207,30,241,31,118,31,118,30,61,31,61,30,61,29,61,28,228,31,16,31,16,30,163,31,163,30,163,29,163,28,158,31,158,30,103,31,126,31,50,31,79,31,61,31,144,31,144,30,252,31,218,31,126,31,87,31,230,31,136,31,190,31,32,31,171,31,205,31,203,31,203,30,203,29,203,28,52,31,16,31,188,31,188,30,188,29,236,31,30,31,136,31,16,31,140,31,90,31,50,31,247,31,93,31,197,31,223,31,223,30,84,31,68,31,124,31,124,30,190,31,190,30,217,31,178,31,225,31,225,30,225,29,176,31,203,31,203,30,174,31,117,31,239,31,173,31,202,31,118,31,173,31,233,31,233,30,155,31,238,31,202,31,108,31,215,31,215,30,114,31,189,31,99,31,99,30,99,29,253,31,144,31,199,31,205,31,240,31,160,31,146,31,74,31,14,31,75,31,75,30,232,31,177,31,20,31,42,31,252,31,34,31,34,30,235,31,246,31,168,31,164,31,152,31,73,31,5,31,35,31,139,31,139,30,107,31,161,31,227,31,227,31,227,30,196,31,185,31,101,31,133,31,94,31,51,31,51,30,77,31,61,31,236,31,236,30,236,29,82,31,51,31,115,31,58,31,129,31,183,31,212,31,36,31,154,31,100,31,100,30,186,31,247,31,125,31,77,31,84,31,245,31,79,31,174,31,174,30,174,29,116,31,233,31,189,31,124,31,124,30,124,29,23,31,23,30,3,31,180,31,81,31,124,31,192,31,90,31,198,31,241,31,126,31,9,31,249,31,176,31,32,31,32,30,173,31,173,30,128,31,128,30,128,29,150,31,87,31,42,31,201,31,201,30,90,31);

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
