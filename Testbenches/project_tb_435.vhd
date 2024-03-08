-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_435 is
end project_tb_435;

architecture project_tb_arch_435 of project_tb_435 is
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

constant SCENARIO_LENGTH : integer := 394;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (214,0,18,0,254,0,0,0,22,0,24,0,158,0,112,0,75,0,150,0,210,0,39,0,0,0,202,0,48,0,145,0,0,0,171,0,40,0,211,0,168,0,0,0,179,0,29,0,0,0,6,0,195,0,0,0,202,0,61,0,135,0,204,0,112,0,164,0,0,0,210,0,84,0,81,0,147,0,0,0,172,0,86,0,182,0,204,0,20,0,0,0,210,0,242,0,30,0,35,0,0,0,0,0,180,0,203,0,127,0,120,0,255,0,58,0,2,0,144,0,164,0,28,0,138,0,160,0,225,0,233,0,141,0,66,0,0,0,239,0,79,0,201,0,254,0,209,0,56,0,0,0,116,0,65,0,232,0,85,0,25,0,206,0,241,0,49,0,132,0,31,0,120,0,138,0,36,0,223,0,249,0,96,0,39,0,0,0,0,0,62,0,0,0,250,0,92,0,90,0,120,0,120,0,156,0,77,0,87,0,124,0,0,0,0,0,0,0,0,0,144,0,0,0,0,0,0,0,29,0,150,0,0,0,0,0,0,0,225,0,191,0,0,0,7,0,168,0,93,0,110,0,55,0,9,0,0,0,119,0,132,0,0,0,0,0,0,0,90,0,184,0,65,0,213,0,76,0,16,0,219,0,0,0,8,0,196,0,64,0,0,0,141,0,8,0,0,0,53,0,224,0,69,0,0,0,0,0,49,0,6,0,190,0,239,0,15,0,52,0,0,0,219,0,0,0,226,0,70,0,21,0,188,0,0,0,0,0,14,0,196,0,81,0,0,0,22,0,85,0,208,0,41,0,0,0,181,0,49,0,0,0,41,0,250,0,224,0,79,0,214,0,77,0,90,0,198,0,225,0,0,0,127,0,192,0,125,0,0,0,99,0,95,0,148,0,6,0,249,0,48,0,109,0,3,0,28,0,100,0,0,0,16,0,0,0,156,0,173,0,83,0,82,0,0,0,37,0,22,0,68,0,136,0,134,0,211,0,0,0,128,0,22,0,0,0,219,0,253,0,142,0,138,0,192,0,156,0,10,0,240,0,101,0,151,0,9,0,147,0,0,0,109,0,158,0,0,0,226,0,79,0,141,0,31,0,0,0,79,0,0,0,0,0,176,0,0,0,100,0,232,0,84,0,128,0,0,0,0,0,208,0,0,0,26,0,113,0,85,0,136,0,42,0,0,0,114,0,249,0,63,0,168,0,26,0,178,0,53,0,0,0,0,0,109,0,133,0,30,0,109,0,232,0,228,0,91,0,8,0,0,0,107,0,132,0,238,0,183,0,147,0,138,0,170,0,157,0,205,0,0,0,114,0,52,0,131,0,193,0,81,0,14,0,226,0,2,0,56,0,82,0,9,0,180,0,0,0,247,0,237,0,0,0,0,0,221,0,123,0,117,0,0,0,147,0,170,0,235,0,144,0,0,0,51,0,210,0,157,0,3,0,231,0,187,0,66,0,0,0,230,0,0,0,0,0,175,0,72,0,254,0,0,0,0,0,0,0,24,0,0,0,0,0,18,0,0,0,0,0,35,0,0,0,80,0,44,0,3,0,21,0,150,0,253,0,122,0,82,0,25,0,144,0,67,0,86,0,123,0,215,0,106,0,206,0,40,0,123,0,31,0,112,0,138,0,65,0,0,0,61,0,0,0,78,0,231,0,130,0,202,0,192,0,163,0,58,0,51,0,0,0,76,0,121,0,250,0,15,0,0,0,131,0,156,0,0,0,135,0,244,0,79,0,0,0,217,0,199,0,124,0,224,0,0,0,0,0);
signal scenario_full  : scenario_type := (214,31,18,31,254,31,254,30,22,31,24,31,158,31,112,31,75,31,150,31,210,31,39,31,39,30,202,31,48,31,145,31,145,30,171,31,40,31,211,31,168,31,168,30,179,31,29,31,29,30,6,31,195,31,195,30,202,31,61,31,135,31,204,31,112,31,164,31,164,30,210,31,84,31,81,31,147,31,147,30,172,31,86,31,182,31,204,31,20,31,20,30,210,31,242,31,30,31,35,31,35,30,35,29,180,31,203,31,127,31,120,31,255,31,58,31,2,31,144,31,164,31,28,31,138,31,160,31,225,31,233,31,141,31,66,31,66,30,239,31,79,31,201,31,254,31,209,31,56,31,56,30,116,31,65,31,232,31,85,31,25,31,206,31,241,31,49,31,132,31,31,31,120,31,138,31,36,31,223,31,249,31,96,31,39,31,39,30,39,29,62,31,62,30,250,31,92,31,90,31,120,31,120,31,156,31,77,31,87,31,124,31,124,30,124,29,124,28,124,27,144,31,144,30,144,29,144,28,29,31,150,31,150,30,150,29,150,28,225,31,191,31,191,30,7,31,168,31,93,31,110,31,55,31,9,31,9,30,119,31,132,31,132,30,132,29,132,28,90,31,184,31,65,31,213,31,76,31,16,31,219,31,219,30,8,31,196,31,64,31,64,30,141,31,8,31,8,30,53,31,224,31,69,31,69,30,69,29,49,31,6,31,190,31,239,31,15,31,52,31,52,30,219,31,219,30,226,31,70,31,21,31,188,31,188,30,188,29,14,31,196,31,81,31,81,30,22,31,85,31,208,31,41,31,41,30,181,31,49,31,49,30,41,31,250,31,224,31,79,31,214,31,77,31,90,31,198,31,225,31,225,30,127,31,192,31,125,31,125,30,99,31,95,31,148,31,6,31,249,31,48,31,109,31,3,31,28,31,100,31,100,30,16,31,16,30,156,31,173,31,83,31,82,31,82,30,37,31,22,31,68,31,136,31,134,31,211,31,211,30,128,31,22,31,22,30,219,31,253,31,142,31,138,31,192,31,156,31,10,31,240,31,101,31,151,31,9,31,147,31,147,30,109,31,158,31,158,30,226,31,79,31,141,31,31,31,31,30,79,31,79,30,79,29,176,31,176,30,100,31,232,31,84,31,128,31,128,30,128,29,208,31,208,30,26,31,113,31,85,31,136,31,42,31,42,30,114,31,249,31,63,31,168,31,26,31,178,31,53,31,53,30,53,29,109,31,133,31,30,31,109,31,232,31,228,31,91,31,8,31,8,30,107,31,132,31,238,31,183,31,147,31,138,31,170,31,157,31,205,31,205,30,114,31,52,31,131,31,193,31,81,31,14,31,226,31,2,31,56,31,82,31,9,31,180,31,180,30,247,31,237,31,237,30,237,29,221,31,123,31,117,31,117,30,147,31,170,31,235,31,144,31,144,30,51,31,210,31,157,31,3,31,231,31,187,31,66,31,66,30,230,31,230,30,230,29,175,31,72,31,254,31,254,30,254,29,254,28,24,31,24,30,24,29,18,31,18,30,18,29,35,31,35,30,80,31,44,31,3,31,21,31,150,31,253,31,122,31,82,31,25,31,144,31,67,31,86,31,123,31,215,31,106,31,206,31,40,31,123,31,31,31,112,31,138,31,65,31,65,30,61,31,61,30,78,31,231,31,130,31,202,31,192,31,163,31,58,31,51,31,51,30,76,31,121,31,250,31,15,31,15,30,131,31,156,31,156,30,135,31,244,31,79,31,79,30,217,31,199,31,124,31,224,31,224,30,224,29);

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
