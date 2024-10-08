-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_616 is
end project_tb_616;

architecture project_tb_arch_616 of project_tb_616 is
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

constant SCENARIO_LENGTH : integer := 380;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (55,0,241,0,212,0,230,0,0,0,0,0,150,0,11,0,18,0,69,0,225,0,64,0,80,0,0,0,146,0,128,0,0,0,0,0,199,0,247,0,106,0,171,0,60,0,61,0,59,0,98,0,250,0,236,0,101,0,14,0,0,0,149,0,45,0,138,0,15,0,0,0,0,0,213,0,139,0,243,0,77,0,42,0,194,0,35,0,69,0,90,0,122,0,168,0,193,0,255,0,254,0,0,0,87,0,0,0,248,0,21,0,171,0,106,0,0,0,213,0,208,0,0,0,18,0,12,0,195,0,249,0,223,0,0,0,200,0,0,0,170,0,0,0,0,0,58,0,203,0,111,0,249,0,1,0,83,0,0,0,33,0,153,0,113,0,87,0,67,0,40,0,140,0,90,0,108,0,162,0,128,0,49,0,81,0,36,0,151,0,215,0,139,0,5,0,37,0,0,0,88,0,104,0,0,0,225,0,0,0,236,0,58,0,0,0,223,0,252,0,255,0,0,0,0,0,124,0,51,0,183,0,171,0,39,0,212,0,0,0,11,0,37,0,240,0,0,0,0,0,239,0,0,0,213,0,91,0,165,0,248,0,0,0,151,0,0,0,60,0,181,0,204,0,17,0,5,0,152,0,0,0,12,0,0,0,115,0,20,0,255,0,168,0,0,0,0,0,238,0,74,0,43,0,65,0,191,0,173,0,0,0,2,0,190,0,0,0,131,0,6,0,231,0,234,0,33,0,175,0,19,0,128,0,158,0,230,0,35,0,200,0,61,0,0,0,137,0,55,0,125,0,223,0,120,0,179,0,73,0,0,0,18,0,0,0,81,0,17,0,228,0,221,0,99,0,239,0,5,0,206,0,53,0,41,0,155,0,50,0,186,0,6,0,81,0,0,0,23,0,0,0,186,0,0,0,0,0,243,0,18,0,109,0,136,0,0,0,151,0,180,0,0,0,0,0,17,0,231,0,184,0,128,0,246,0,106,0,43,0,110,0,244,0,0,0,75,0,102,0,64,0,29,0,253,0,115,0,142,0,147,0,163,0,232,0,191,0,109,0,0,0,214,0,0,0,57,0,45,0,57,0,145,0,242,0,73,0,21,0,28,0,0,0,142,0,0,0,39,0,0,0,148,0,109,0,247,0,102,0,79,0,98,0,247,0,133,0,40,0,111,0,103,0,233,0,0,0,0,0,0,0,59,0,140,0,150,0,103,0,222,0,147,0,144,0,6,0,138,0,0,0,0,0,0,0,35,0,124,0,176,0,62,0,197,0,219,0,223,0,145,0,59,0,94,0,235,0,211,0,198,0,230,0,100,0,0,0,190,0,220,0,0,0,200,0,0,0,247,0,19,0,76,0,0,0,1,0,84,0,0,0,98,0,192,0,43,0,22,0,216,0,167,0,175,0,109,0,0,0,0,0,48,0,68,0,3,0,0,0,110,0,140,0,246,0,0,0,80,0,71,0,0,0,161,0,141,0,35,0,91,0,10,0,169,0,138,0,179,0,245,0,0,0,0,0,77,0,206,0,221,0,75,0,204,0,57,0,0,0,0,0,86,0,157,0,0,0,211,0,232,0,106,0,52,0,59,0,121,0,0,0,26,0,106,0,154,0,95,0,102,0,10,0,172,0,0,0,69,0,167,0,77,0,0,0,115,0,13,0,0,0,0,0,248,0,205,0,237,0,0,0,101,0,157,0,198,0,26,0);
signal scenario_full  : scenario_type := (55,31,241,31,212,31,230,31,230,30,230,29,150,31,11,31,18,31,69,31,225,31,64,31,80,31,80,30,146,31,128,31,128,30,128,29,199,31,247,31,106,31,171,31,60,31,61,31,59,31,98,31,250,31,236,31,101,31,14,31,14,30,149,31,45,31,138,31,15,31,15,30,15,29,213,31,139,31,243,31,77,31,42,31,194,31,35,31,69,31,90,31,122,31,168,31,193,31,255,31,254,31,254,30,87,31,87,30,248,31,21,31,171,31,106,31,106,30,213,31,208,31,208,30,18,31,12,31,195,31,249,31,223,31,223,30,200,31,200,30,170,31,170,30,170,29,58,31,203,31,111,31,249,31,1,31,83,31,83,30,33,31,153,31,113,31,87,31,67,31,40,31,140,31,90,31,108,31,162,31,128,31,49,31,81,31,36,31,151,31,215,31,139,31,5,31,37,31,37,30,88,31,104,31,104,30,225,31,225,30,236,31,58,31,58,30,223,31,252,31,255,31,255,30,255,29,124,31,51,31,183,31,171,31,39,31,212,31,212,30,11,31,37,31,240,31,240,30,240,29,239,31,239,30,213,31,91,31,165,31,248,31,248,30,151,31,151,30,60,31,181,31,204,31,17,31,5,31,152,31,152,30,12,31,12,30,115,31,20,31,255,31,168,31,168,30,168,29,238,31,74,31,43,31,65,31,191,31,173,31,173,30,2,31,190,31,190,30,131,31,6,31,231,31,234,31,33,31,175,31,19,31,128,31,158,31,230,31,35,31,200,31,61,31,61,30,137,31,55,31,125,31,223,31,120,31,179,31,73,31,73,30,18,31,18,30,81,31,17,31,228,31,221,31,99,31,239,31,5,31,206,31,53,31,41,31,155,31,50,31,186,31,6,31,81,31,81,30,23,31,23,30,186,31,186,30,186,29,243,31,18,31,109,31,136,31,136,30,151,31,180,31,180,30,180,29,17,31,231,31,184,31,128,31,246,31,106,31,43,31,110,31,244,31,244,30,75,31,102,31,64,31,29,31,253,31,115,31,142,31,147,31,163,31,232,31,191,31,109,31,109,30,214,31,214,30,57,31,45,31,57,31,145,31,242,31,73,31,21,31,28,31,28,30,142,31,142,30,39,31,39,30,148,31,109,31,247,31,102,31,79,31,98,31,247,31,133,31,40,31,111,31,103,31,233,31,233,30,233,29,233,28,59,31,140,31,150,31,103,31,222,31,147,31,144,31,6,31,138,31,138,30,138,29,138,28,35,31,124,31,176,31,62,31,197,31,219,31,223,31,145,31,59,31,94,31,235,31,211,31,198,31,230,31,100,31,100,30,190,31,220,31,220,30,200,31,200,30,247,31,19,31,76,31,76,30,1,31,84,31,84,30,98,31,192,31,43,31,22,31,216,31,167,31,175,31,109,31,109,30,109,29,48,31,68,31,3,31,3,30,110,31,140,31,246,31,246,30,80,31,71,31,71,30,161,31,141,31,35,31,91,31,10,31,169,31,138,31,179,31,245,31,245,30,245,29,77,31,206,31,221,31,75,31,204,31,57,31,57,30,57,29,86,31,157,31,157,30,211,31,232,31,106,31,52,31,59,31,121,31,121,30,26,31,106,31,154,31,95,31,102,31,10,31,172,31,172,30,69,31,167,31,77,31,77,30,115,31,13,31,13,30,13,29,248,31,205,31,237,31,237,30,101,31,157,31,198,31,26,31);

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
