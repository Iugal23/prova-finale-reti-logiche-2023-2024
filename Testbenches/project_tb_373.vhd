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

constant SCENARIO_LENGTH : integer := 171;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (191,0,0,0,249,0,0,0,185,0,39,0,41,0,205,0,217,0,0,0,236,0,55,0,184,0,181,0,57,0,150,0,0,0,83,0,117,0,162,0,203,0,65,0,238,0,65,0,195,0,106,0,216,0,232,0,215,0,166,0,73,0,7,0,185,0,0,0,2,0,104,0,0,0,130,0,0,0,242,0,52,0,255,0,0,0,113,0,195,0,185,0,192,0,28,0,0,0,170,0,190,0,93,0,210,0,41,0,101,0,206,0,71,0,0,0,62,0,206,0,0,0,80,0,244,0,0,0,32,0,28,0,0,0,55,0,0,0,200,0,10,0,0,0,129,0,42,0,246,0,125,0,158,0,0,0,0,0,86,0,50,0,0,0,170,0,219,0,7,0,39,0,219,0,17,0,105,0,0,0,0,0,151,0,125,0,0,0,0,0,164,0,24,0,87,0,193,0,41,0,236,0,178,0,178,0,204,0,220,0,157,0,138,0,67,0,106,0,67,0,224,0,0,0,145,0,75,0,151,0,0,0,204,0,0,0,232,0,156,0,58,0,0,0,49,0,41,0,84,0,0,0,147,0,0,0,29,0,0,0,0,0,0,0,200,0,101,0,0,0,210,0,247,0,0,0,0,0,29,0,91,0,0,0,106,0,168,0,0,0,228,0,89,0,170,0,91,0,102,0,98,0,37,0,223,0,0,0,166,0,19,0,195,0,11,0,136,0,209,0,0,0,111,0,186,0,71,0,16,0,87,0,0,0,69,0,183,0,93,0,171,0);
signal scenario_full  : scenario_type := (191,31,191,30,249,31,249,30,185,31,39,31,41,31,205,31,217,31,217,30,236,31,55,31,184,31,181,31,57,31,150,31,150,30,83,31,117,31,162,31,203,31,65,31,238,31,65,31,195,31,106,31,216,31,232,31,215,31,166,31,73,31,7,31,185,31,185,30,2,31,104,31,104,30,130,31,130,30,242,31,52,31,255,31,255,30,113,31,195,31,185,31,192,31,28,31,28,30,170,31,190,31,93,31,210,31,41,31,101,31,206,31,71,31,71,30,62,31,206,31,206,30,80,31,244,31,244,30,32,31,28,31,28,30,55,31,55,30,200,31,10,31,10,30,129,31,42,31,246,31,125,31,158,31,158,30,158,29,86,31,50,31,50,30,170,31,219,31,7,31,39,31,219,31,17,31,105,31,105,30,105,29,151,31,125,31,125,30,125,29,164,31,24,31,87,31,193,31,41,31,236,31,178,31,178,31,204,31,220,31,157,31,138,31,67,31,106,31,67,31,224,31,224,30,145,31,75,31,151,31,151,30,204,31,204,30,232,31,156,31,58,31,58,30,49,31,41,31,84,31,84,30,147,31,147,30,29,31,29,30,29,29,29,28,200,31,101,31,101,30,210,31,247,31,247,30,247,29,29,31,91,31,91,30,106,31,168,31,168,30,228,31,89,31,170,31,91,31,102,31,98,31,37,31,223,31,223,30,166,31,19,31,195,31,11,31,136,31,209,31,209,30,111,31,186,31,71,31,16,31,87,31,87,30,69,31,183,31,93,31,171,31);

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
